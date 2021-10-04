# vscode
VSCode template for CDK development workspace

public dockder image:

`public.ecr.aws/pahudnet/vscode:latest`

# AWS SSO for AWS CDK

Configure your `default` AWS_PROFILE with AWS SSO
```sh
aws configure sso --profile default 
```

Configure `credential_process` for the `default` profile

```sh
aws configure set credential_process ${PWD}/.devcontainer/bin/aws-sso-credential-process
```

AWS CLI requires the `~/.aws/credentials` file so we simple touch an empty one to get rid of the warning.

```sh
touch ~/.aws/credentials && chmod 600 $_
```
