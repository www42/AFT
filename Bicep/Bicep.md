[alex-frankel-channel9]: https://channel9.msdn.com/Shows/DevOps-Lab/Project-Bicep--Next-generation-ARM-Templates
[ms-learn-arm-path]: https://docs.microsoft.com/en-us/learn/paths/deploy-manage-resource-manager-templates/

![Alex Frankel on Channel 9](img/alex-frankel-channel9.png)
[Click here for the video][alex-frankel-channel9]

![What is Project Bicep](img/what-is-project-bicep.png)

There is a [learning path][ms-learn-arm-path] in MS Learn on ARM templates.

[Releases](https://github.com/Azure/bicep/releases)

[v0.3 Milestone](https://github.com/Azure/bicep/milestone/4)


### Microsoft's answer to Terraform

* VS Code support
* Bicep compile
* Bicep decompile
* Bicep modules

### No more `dependsOn`

There is no `dependsOn` in bicep file. Dependencies are added by bicep build.

### How to start?

* Install bicep
* Install VS Code extension
* Type `resource` in a new file named foo.bicep. The file name .bicep will activate the bicep language server in VS Code.

![Start typing](img/start-typing.png)