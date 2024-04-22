# frozen_string_literal: true

directory '/tmp/acc' do
  owner 'oracle'
end

directory "/tmp/acc/#{node[:local_id]}" do
  owner 'oracle'
end

template "/tmp/acc/#{node[:local_id]}/view.sql" do
  source "templates/tmp/acc/view.sql.erb"
  variables(
    local_id: node[:local_id],
    prefix_name: node[:prefix_name],
  )
  owner 'oracle'
  mode '0755'
end

template "/tmp/acc/#{node[:local_id]}/realm.sql" do
  source "templates/tmp/acc/realm.sql.erb"
  variables(
    username: node[:username],
  )
  owner 'oracle'
  mode '0755'
end
