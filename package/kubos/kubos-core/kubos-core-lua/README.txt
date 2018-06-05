This is a placeholder package until the underlying files are converted to Rust

Steps to create a new package for each of the underlying services:
------------------------------------------------------------------

1.  Create a new package folder under the `kubos-core` parent folder (you can copy one of the existing folders if you like).
    - The folder name should be `kubos-core-{something-descriptive}` 
    - The folder should contain three files:
        - Config.in - The KConfig menuoptions for the package
        - {folder-name} - The init script for the service
        - {folder-name}.mk - The build file for the service
        
2. Edit Config.in to contain the following sections
    - menuconfig BR2_PACKAGE_KUBOS_CORE_{YOUR_PACKAGE} (needed for the init_lvl option)
    - config BR2_PACKAGE_KUBOS_CORE_{YOUR_PACKAGE}_INIT_LVL - Init script init level
    - config BR2_PACKAGE_HAS_KUBOS_CORE_{YOUR_PACKAGE} - Needed for virtual package stuff
    - config BR2_PACKAGE_PROVIDES_KUBOS_CORE_{YOUR_PACKAGE} - Needed for virtual package stuff
    
3. Edit {folder-name} (the init script) to have the name of your service in the `NAME` envar

4. Edit {folder-name}.mk
    - Use an existing package Makefile, just change the package name
    - There are a couple places that don't use "kubos-core-{package}" and instead just have `{something}-service`.
      This is the name of the actual project/application/service that's getting built
        
5. Edit `kubos-core/Config.in`
    - Add `select BR2_PACKAGE_KUBOS_CORE_{YOUR_PACKAGE}`
    - Add a `source` line pointing to the new folder's Config.in

6. Navigate to the main buildroot-2017.02.8 folder

7. Verify your new menu options
    - `sudo make menuconfig`
    - External options -> (potentially selecting 'Kubos Linux BR2_EXTERNAL Tree') -> Kubos Packages -> Kubos Core Services -> Your new package
    - Your package should be automatically selected. The init level option should be available by going into your package's menu
    - Exit repeteadly until it asks you if you want to save your config. Say yes.
    
8. Build your package
    - `sudo make kubos-core-{your-package}`
    
9. Verify the files got copied into the target directory
    - buildroot-2017.02.8/output/target
    - Init scripts go into 'etc/init.d'
    - Binaries go into 'usr/sbin'