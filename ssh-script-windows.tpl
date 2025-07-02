# windows-ssh-script.tpl
add-content -path "C:\users\${ssh_user}\.ssh\config" -value @'

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityfile}
'@