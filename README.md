# todo-app-postgress

todo app from a geeks for geeks tutorial converted to docker, modified to use postgress

how 2 use:

- download n run docker
- git clone to a repository
- run "docker compose up --build"
- access via localhost:8080

running on render:
- create a new postgress db on render
- copy the internal db url
- create a new web service on render, make a new environment variable named "DATABASE_URL" and paste the internal db url  
- ur done

tulay.
