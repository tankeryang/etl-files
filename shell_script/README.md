# SHELL 脚本

## pack2zip.sh

### usage

```shell
sh shell_script/pack2zip.sh --zip-name <压缩包名> --dir-name <job文件夹名>
```

### example

- 先进入 __项目主目录__ (假设你的项目在`~/etl-file`)
    ```shell
    > $ cd ~/etl-file
    ```

- 执行如下命令打包`dwh/job/crm-loop` (假设你在`dev-crm`分支下)
    ```shell
    > $ sh shell_script/pack2zip.sh --zip-name dev-crm-loop --dir-name crm-loop
    ```

### attention

__注意：一定要在项目主目录下执行，否则后果自负__