#Hieracrypta

A small server-based  solution to the need to deliver secrets to arbitrary new machines running puppet and hiera.

###The problem

Brand new machines have no trust relationship with other machines.  We want to deploy secret information to them such as keys for interactions with other services.  We need a lightweight way to create a trust relationship and deliver information without substantially increasing the deployment activity.  We would also like to be able to update automatedly secrets.

####The high level solution

* Each server, at provision time, creates an identity and a key pair for that identity.
* The deployer signs the new server’s public key.
* The new server identifies itself to the hieracrypta service and becomes trusted.
* Requests for information from the hieracrypta service are returned encrypted for a specified identity.  As only the new server has the private key, hieracrypta does not need to worry about giving this information to any requester.

###Technical details

* Each server, at provision time, creates an identity and a gpg key pair for that identity.
* The deployer, from their own machine, fetches, signs (using their private key), and returns to the new server the public key.
* The new server is configured to fetch gpg encrypted yaml files via a REST API which has access to our git repository.
* This REST API is delivered by the hieracrypta service.
* The hieracrypta service has access to our git repository, where deployers’ public keys are held on record.
* On receiving a signed public key and identity, the hieracrypta server can check it trusts that identity via the public key for the deployer.
* The hieracrypta server will then respond to requests for information via the REST API, fetching the information from our git repo, and returning the information re-encrypted for the new server.
* The secrets must therefore be symmetrically encrypted in our git repo, for decode by all admins plus the hieracrypta server.

###Implementation
####Service Delivery
* Hieracrypta will be implemented as a Ruby library wrapped in a service layer (eg Sinatra).
* Hieracrypta will be delivered as a gem (immediatly) and as a package (later).

The Hieracrypta Server will be built using puppet, plus manual configuration by ssh to configure git keys.

####Client Implementation
To be discussed

####Deployer Implementation
* SSH GET a file containing a private key from server.
* SSH GET a file containing an identity from server.
* Construct a JSON file and sign it.
* SSH PUT the signed file back to the server.

JSON Object Structure
```
{
“id”:	{id}
“pubkey”:	{pubkey}
“allow”:	{
	“branch”:	[{branch list}]
	“tag”:	[{tag list}]
}
“deny”: {
	“branch”:	[{branch list}]
	“tag”:	[{tag list}]
}
}
```
Where:
id is mandatory
pubkey is mandatory
allow is optional - missing == allow all
branch is optional - missing == allow all
tag is optional - missing == allow all
deny is optional - missing == deny none
branch is optional - missing == deny none
tag is optional - missing == deny none

###REST API (Must)
PUT /identities/ + body comprising a signed json object which 
Returns 
200 if the request is well formed and signed
400 if the request body is not well formed 
403 if the request body is not signed by a known administrator

GET /file/{identity}/branches/{branch}/{file}
Returns
200 + body comprising encrypted yaml file if the identity, branch, and file are known and the branch is allowed
403 if the identity, branch, and file are known but the branch is not allowed
404 if the identity, branch or file are not known

GET /file/{identity}/tags/{tag}/{file}
Returns
200 + body comprising encrypted yaml file if the identity, tag, and file are known and the tag is allowed
403 if the identity, tag, and file are known but the tag is not allowed
404 if the identity, tag or file are not known

###REST API (Could)
GET /identities/
Returns
200 + list of known identity names

GET /identities/{identity}
Returns
200 + body comprising public key of specified identity if the identity is known
404 if the identity is not known
