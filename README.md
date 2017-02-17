# taskR

Web Application. Does time tracking for IHK trainees who need to print a report of their weekly progress and activities. Made with Ruby and Rails. Runs on Heroku.  

[https://task-r.herokuapp.com/](https://task-r.herokuapp.com/)  

**Fork and deploy to your own Heroku account to use.**  
*Free Postgres database on Heroku is limited to 10000 rows.*  

## development

required environment variables:  

```
TASKR_DATABASE_USERNAME  
TASKR_DATABASE_PASSWORD  
SECRET_KEY_BASE_DEVELOPMENT  
SECRET_KEY_BASE_TEST  
SECRET_KEY_BASE  
```

run:  

```
source .env  
bundle exec rails s  
```

## production

the heroku postgres database is limited to 10000 rows.  

## backup production database from heroku to local postgres database

postgres version should be: 9.5.5  

get info about postgres from heroku:  

```
heroku pg:info --app task-r  
```

get info on the local postgres database version:  

```
psql -V  
```

connect to the local postgres database and list all databases:  

```
sudo su postgres  
(enter your sudo password)  
psql  
\l  
```

create user with password and alter roles:  

```mysql  
CREATE USER nd WITH PASSWORD '`echo $TASKR_DATABASE_USERNAME`';  
ALTER ROLE nd WITH CREATEROLE;  
ALTER ROLE nd WITH CREATEDB;  
```

if it exists, drop the local database before pulling from heroku:  

```mysql  
DROP DATABASE "taskR_development"  
\q  
exit  
```

and backup the production database from heroku to your local postgres database:  

```
source .env  
PGUSER=`echo $TASKR_DATABASE_USERNAME` PGPASSWORD=`echo $TASKR_DATABASE_PASSWORD` heroku pg:pull DATABASE taskR_development --app task-r  
(enter your heroku credentials: email and password)  
```

(note: you can push from local to production with the same command, just change pull to push)  

## publish changes to production environment on heroku

deploy changes from master to heroku:  

```
git push heroku master  
```

deploy changes from branch to heroku (**bad practice!**):  

```
git push heroku branchname:master  
```

deploy migrations on heroku:  

```
heroku run rake db:migrate --app task-r  
```

## expand your models

```
rails generate migration AddColumnNameToPost column_name:string  
```

then run  

```
bundle exec rake db:migrate  
```

now add validations to model, make it interactable in the views form, add it to the allowed parameters in the controller and you can use it.  
