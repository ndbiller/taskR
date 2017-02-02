# taskR

time tracking web application for trainees  

[https://task-r.herokuapp.com/](https://task-r.herokuapp.com/)  

## development

required environment variables:  

- TASKR_DATABASE_USERNAME  
- TASKR_DATABASE_PASSWORD  
- SECRET_KEY_BASE_DEVELOPMENT  
- SECRET_KEY_BASE_TEST  
- SECRET_KEY_BASE  

run:  

source .env  
bundle exec rails s  

## production

the heroku postgres database is limited to 10000 rows.  

## backup heroku database to local database

postgres version should be: 9.5.5  

get info about postgress from heroku:  

heroku pg:info --app task-r  

get info on the local postgres database version:  

psql -V  

connect to the local postgres database and list all databases:  

sudo su postgres  
(enter your sudo password)  
psql  
\l  
\q  
exit  

drop the local database before you pull the new one from heroku:  

sudo su postgres  
(enter your sudo password)  
dropdb taskR_development  
exit  

backup the database from heroku to the local database:  

source .env  
PGUSER=`echo $TASKR_DATABASE_USERNAME` PGPASSWORD=`echo $TASKR_DATABASE_PASSWORD` heroku pg:pull DATABASE taskR_development --app task-r  
(enter your heroku credentials: email and password)  

