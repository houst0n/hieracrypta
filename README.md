# hieracrypta - Serve gpg encrypted secrets to your puppet nodes

`hieracrypta` is simple webservice which provides encrypted
yaml files to your masterless puppet nodes which present a 
key signed by a trusted source.

This allows you to use encrypted secrets without having to 
continually re-encrypt your secrets.

# Usage

```shell
$ ./bin/hieracrypta start
```

`rake -T` should produce a list of tasks which will get you started.
