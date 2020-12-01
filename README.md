# Hyper-V Homelab

An amalgamation of powershell and bash scripts to provision and prepare Hyper-V vms through WSL.  
More usage documentation to come with output examples of each command in the wiki.

Usage:

```
Usage: homelab.sh command [options]
Commands: provision, start, stop, prep, destroy, list, templates, mod_template, login, console, wsl_forward

    provision            Provision a VM, optionally starting and prepping it
    start                Start a VM
    stop                 Stop a VM
    prep                 Prep VM for login (copy key, set hostname) - Must be running
    destroy              Delete a VM
    login                Display login information
    console              Run vmconnect to open Hyper-V console for given VM
    list                 List all current Hyper-V VMs
    templates            List available template files
    mod_template         Modify attributes for the given template
    wsl_forward          Display powershell command to enable forwarding between WSL and Hyper-V guests

    General Arguments:
    -h|--help            Display this helpfile
    -n|--name            VM Name - Usable with provision, start, stop, prep, destroy, login, console
    -t|--template        Template File - Usable with provision, mod_template
    -c|--cores           Number of virtual cpu cores - Usable with provision
    -m|--memory          VM Ram allocation in MB (ie 3072 for 3GB) - Usable with provision
    -s|--start           Run VM start after provision - Usable with provision
    -p|--prep            Run VM prep after start - Usable with provision, start
    -u|--user            User to log into vm with, default 'root' - Usable with login
    --create_task        Create scheduled task to auto apply wsl_forward powershell command at login. - Usable with wsl_forward
    --distrover          Set the 'distrover' attribute on the given template - Usable with mod_template
    --description        Set the 'description' attribute on the given template - Usable with mod_template

Example: ./homelab.sh provision -n "Cent8 Test" -p -s -m 2048 -c 2 -t "Cent8-Base.vhdx"

The above will provision a VM named "Cent8 Test" with 2 vCPUs and 2GB RAM from the "Cent8-Base.vhdx" template.
It will also start the VM after provisioning, and run the prep function (copy key in and set hostname).

Example: ./homelab.sh mod_template --distrover "CentOS 7" --description "Base Image" -t "Cent7-Base.vhdx"

The above will set the distrover to "CentOS 7" and description to "Base Image" on the "Cent7-Base.vhdx" template file.
```
