FROM nginx

ADD  /abs-guide /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
