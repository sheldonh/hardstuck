# README

AWS Cloud9 installation notes:

```
sudo amazon-linux-extras enable postgresql9.6
sudo yum clean metadata
sudo yum install -y postgresql-devel postgresql-server
sudo postgresql-setup initdb
sudo sed -i -e 's/^\(local.*\)peer/\1trust/' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo -u postgres createuser -d hardstuck

rvm get stable
rvm install 2.7
rvm use 2.7 --default
gem install --no-doc -v '~> 6.1' rails
gem install --no-doc pg

curl -o- -L https://yarnpkg.com/install.sh | bash
. ~/.bashrc
rails new hardstuck -d postgresql
cd hardstuck
sed -i -e 's/^\(default:.*\)/\1\n  username: hardstuck/' config/database.yml

C9_HOST="${C9_PID}.vfs.cloud9.$(echo "${HOSTNAME}" | awk -F. '{print $2}').amazonaws.com"
sed -i -e 's/^\(Rails.application.configure.*\)/\1\n  config.hosts << "'${C9_HOST}'"/' config/environments/development.rb

rails db:create db:migrate
rails server -b 0.0.0.0
```
