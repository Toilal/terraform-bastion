# This template data source is created for each user specified in the additional_users module input.
# The below template(s) will be rendered in the bastion-userdata.tmpl template.
data "template_file" "additional_user" {
  count = length(var.additional_users)

  vars = {
    # The additional_users input is a list of maps.
    user_login = lookup(var.additional_users[count.index], "login")
    # If gecos is nset, default to the user-name.
    user_gecos = lookup(
      var.additional_users[count.index],
      "gecos",
      lookup(var.additional_users[count.index], "login"),
    )
    # If shell is isn't set, default to bash.
    user_shell               = lookup(var.additional_users[count.index], "shell", "/bin/bash")
    user_supplemental_groups = lookup(var.additional_users[count.index], "supplemental_groups", "")
    user_authorized_keys     = lookup(var.additional_users[count.index], "authorized_keys")
    user_sudo                = replace(lookup(var.additional_external_users[count.index], "supplemental_groups"), "sudo", "<REPLACED>") != lookup(var.additional_external_users[count.index], "supplemental_groups")
  }

  template = <<EOF
info "Creating user:"
# The printf string is put in single-quotes because it may contain it's own double-quotes.
printf '  Login: \"$${user_login}\"\n'

# The ssh_keys variable is put in single-quotes because it may contain it's own double-quotes.
if [ '$${user_authorized_keys}x' == "x" ]; then
  info "authorized_keys are required, but were not provided - the above user will not be created."
else
  useradd -s $${user_shell} -c "$${user_gecos}" -m $${user_login}
  [ "$${user_supplemental_groups}x" != "x" ] && usermod -G $${user_supplemental_groups} $${user_login}
  info "Populating authorized_keys for $${user_login}"
  mkdir ~$${user_login}/.ssh
  # The ssh_keys variable is put in single-quotes because it may contain it's own double-quotes.
  printf '$${user_authorized_keys}' > ~$${user_login}/.ssh/authorized_keys
  chown -R $${user_login}:$${user_login} ~$${user_login}/.ssh
  chmod -R go= ~$${user_login}/.ssh
%%{~ if user_sudo }
  printf '$${user_login} ALL=(ALL) NOPASSWD:ALL'>/etc/sudoers.d/95-nopasswd-$${user_login}
%%{ endif ~}
fi
EOF
}

