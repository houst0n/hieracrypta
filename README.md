#Hieracrypta

A small server-based solution to the need to deliver secrets to arbitrary new machines running puppet and hiera.

##The Problem

Brand new machines have no trust relationship with other machines.   
We want to deploy secret information to them such as keys for interactions with other services.   
We need a lightweight way to create a trust relationship and deliver/update information.   
We do not want to increase deployment activities. 

##The High Level Solution

* Each server, at provision time, creates an identity and a key pair for that identity.
* The deployer signs the new server's public key.
* The new server identifies itself to the hieracrypta service and becomes trusted.
* Requests for information from the hieracrypta service are returned encrypted for a specified identity.  As only the new server has the private key, hieracrypta does not need to worry about giving this information to any requester.

##Implementation

###Technical Details

* Each server, at provision time, creates an identity and a gpg key pair for that identity.
* The deployer, from their own machine, fetches the identity and public key from the new server
* The deployer constructs and signs a permission document, signs the document (using their private key).
* The deployer returns the signed document to the new server.
* The new server is configured to fetch gpg encrypted files via a REST API.
* This REST API is delivered by the hieracrypta service.
* The hieracrypta service has access to a git repository, where deployers' public keys are held on record.
* On receiving a signed permission document, the hieracrypta server can check it if it should now trust that identity via the public keys for the deployers.
* The hieracrypta server will then respond to requests for information via the REST API, fetching the information from the git repo, and returning the information re-encrypted for the new server.

* The secrets must therefore be symmetrically encrypted in the git repo, for decode by all admins plus the hieracrypta server.


###Service Delivery
* Hieracrypta will be implemented as a Ruby library wrapped in a service layer (eg Sinatra).
* Hieracrypta will be delivered as a gem (immediately) and as a package (later).

The Hieracrypta Server will be built using puppet, plus manual configuration by ssh to configure git keys.

###Client Implementation
To be discussed

###Deployer Implementation
* SSH GET a file containing a private key from server.
* SSH GET a file containing an identity from server.
* Construct a permissions document and sign it.
* SSH PUT the signed file back to the server.

##JSON Permissions Document Structure
<pre>
{
	"id":	{id},
	"pubkey":	{pubkey},
	"allow":	{
		"branch":	[{branch list}],
		"tag":	[{tag list}]
	},
	"deny": {
		"branch":	[{branch list}],
		"tag":	[{tag list}]
	}
}
</pre>

Where:

* id is mandatory
* pubkey is mandatory
* allow is optional - missing == allow all
 * branch is optional - missing == allow all; present == allow only these
 * tag is optional - missing == allow all; present == allow only these
* deny is optional - missing == deny none
 * branch is optional - missing == deny none; present == deny only these
 * tag is optional - missing == deny none; present == deny only these

##REST API 

###Must

####PUT /identities/ + body comprising a signed json object 

If the request is well formed and signed

* HTTP 200 

If the request body is not well formed

* HTTP 400 + body describing error reason

If the request body is not signed by a known administrator
 
* HTTP 403 + body describing error reason

####GET /file/{identity}/branches/{branch}/{file}

If the identity, branch, and file are known and the branch is allowed

* HTTP 200 + body comprising encrypted file

If the identity, branch, and file are known but the branch is not allowed
 
* HTTP 403 + body describing error reason 

If the identity, branch or file are not known

* HTTP 404 + body describing error reason

####GET /file/{identity}/tags/{tag}/{file}

If the identity, tag, and file are known and the tag is allowed

* HTTP 200 + body comprising encrypted file 

If the identity, tag, and file are known but the tag is not allowed

* HTTP 403 + body describing error reason

If the identity, tag or file are not known

* HTTP 404 + body describing error reason

###Could

Mostly useful for debugging from the server

####GET /identities/

* HTTP 200 + body comprising json object containing one item: "identities": [{list of known identity names}]

####GET /identities/{identity}

If the identity is known

* HTTP 200 + body comprising json object containing one item: "pubkey": public key on record for {identity} 

If the identity is not known

* HTTP 404 + body describing error reason

####GET /search/{identity}/branches/

If the identity is known

* HTTP 200 + body comprising json object containing one item: "branches": [list of allowed branches] 

If the identity is not known

* HTTP 404 + body describing error reason

####GET /search/{identity}/branches/{branch}/{file}

If the identity is known

* HTTP 200 + body comprising json object containing one item: "files": [list of files matching {file} in {branch}] 

If the identity is not known

* HTTP 404 + body describing error reason

####GET /search/{identity}/tags/

If the identity is known

* HTTP 200 + body comprising json object containing one item: "tags": [list of allowed tags]

If the identity is not known

* HTTP 404 + body describing error reason

####GET /search/{identity}/tags/{tag}/{file}

If the identity is known

* HTTP 200 + body comprising json object containing one item: "files": [list of files matching {file} in {tag}] 

If the identity is not known

* HTTP 404 + body describing error reason

