# README

AWS Cloud9 Amazon Linux 2 installation notes:

```
sudo amazon-linux-extras enable postgresql9.6
sudo yum clean metadata
sudo yum install -y postgresql-devel postgresql-server
sudo postgresql-setup initdb
sudo sed -i -e 's/^\(local.*\)peer/\1trust/' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo -u postgres createuser -s hardstuck
```

AWS Cloud9 Ubuntu 18.04 installation notes:

```
sudo apt update
sudo apt install -y chromium-chromedriver
sudo apt install postgresql-client postgresql libpq-dev postgresql-contrib
sudo sed -i -e 's/^\(local.*\)peer/\1trust/' /var/lib/pgsql/data/pg_hba.conf
sudo systemctl restart postgresql
sudo -u postgres createuser -s hardstuck
```

AWS Cloud9 common installation notes:

```
git config --global user.name "Sheldon Hearn"
git config --global user.email "sheldonh@starjuice.net"

rvm get stable
rvm install 2.7
rvm use 2.7 --default
gem install --no-doc -v '~> 6.1' rails
gem install --no-doc pg

curl -o- -L https://yarnpkg.com/install.sh | bash
. ~/.bashrc
```

rails init:

```
rails new hardstuck -d postgresql
cd hardstuck
sed -i -e 's/^\(default:.*\)/\1\n  username: hardstuck/' config/database.yml
bundle config --local disable_platform_warnings true
```

rails clone:

```
ssh-keygen
# Add deploy key with write access to GitHub project
git clone git@github.com:sheldonh/hardstuck.git
cd hardstuck
bundle config --local disable_platform_warnings true
bundle
yarn install
```

Startup:

```
C9_HOST="${C9_PID}.vfs.cloud9.$(hostname --fqdn | awk -F. '{print $2}').amazonaws.com"
sed -i -e 's/^\(Rails.application.configure.*\)/\1\n  config.hosts << "'${C9_HOST}'"/' config/environments/development.rb

rails db:create db:migrate
rails server -b 0.0.0.0
```

Fantasy code:

```
match = Match.create(winner: member1, loser: member2, draw: true)
match.ranking_changes
# => []

match = Match.create(winner: winner, loser: loser, draw: false)
ranking_changes = match.ranking_changes
# => [Member<...>, Member<...>, ...]
puts ranking_changes.map { |x| x.changes }.to_yaml
# ---
# - rank:
#   - 1
#   - 2
# - rank:
#   - 2
#   - 3
# - rank:
#   - 3
#   - 2

ranking_changes.each { |x| x.save! }
# or perhaps 
match.apply_ranking_changes

# Probably want a RankingChange model, but let's not get carried away just yet.
```
