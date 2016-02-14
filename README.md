Run chantry's Twilight Struggle server in Docker. Very nice!

# Setup

Clone the `chantry-website` and `chantry-ts` repos from https://bitbucket.org/arry/chantry-website.

## Bugfix

You may have to make a small modification to `chantry-website/main/lib/Chantry/WebApp.pm`
and `chantry-website/main/templates/games/play.html.tt` if you're unable to
load the `ts` module in the browser. Find these lines and change `${game_code}.js`
to `${game_code}_bundle.js`:

```
# chantry-website/main/lib/Chantry/WebApp.pm
$self->asset("${game_code}.js" => (

# chantry-website/main/templates/games/play.html.tt
[% additional_page_js = "${game_code}.js" %]
```

# Local hacking

`docker-compose build && docker-compose up`.

# Deploying

`REPO=your.docker.registry ./docker-build` will build the app and Perl/PostgreSQL
container, push the app container to the registry, and export the data container
to a `.tar.bz2` file. You can then use the Ansible playbook to do the deploy to
a remote Docker host:

```
REPO=your.docker.registry \
EXTERNAL_HOST=www.deployed.location \
EXTERNAL_PORT=45678 \
ansible-playbook playbook.yml -e with_perl=1 -i hosts
```

Set `with_perl=0` to not push a new Perl/PostgreSQL data container.

## Adding users

Generate passwords with `docker exec -i chantry create_pw $password`.
Add them to a SQL file (let's say `users.sql`) with this format:

``` sql
INSERT INTO chantry.users (username, password_hash, email)
VALUES ('john', 'password-from-create_pw', 'john@example.com');
```

Pipe that file into PostgreSQL:

`docker exec -i chantry chpst -u postgres psql -d chantry -a < ./users.sql`

