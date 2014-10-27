#Clonesy

This project was created as part of a collaborative 4 person gSchool project. We inherited a legacy code base, refactored, increased the test converage and quality before creating the Aphagram e-commerce store.

Aphagram is an Etsy clone which leveraged subdomains to allow users of the site to create their own stores, upload their products and sell them through Aphagram. As part of this 4 person team, we were quite proud of our TDD process and maintained excellent test quality and coverage throughout the build. I am most proud of my implementation of the admin statistics dashboard which used Morris.js and the Raphael JS graphing library to visualize admin sales statistics.

###What to look for
* Test Quality
* Morris/Raphael JS

****

###Getting started locally with Aphagram
* Clone down the repo
  * git clone git@github.com:phoenixbox/clonesy.git
* Bundle the gems
  * bundle install
* Create the database, migrate it, create the seed data, set-up the tests
  * rake db:create db:migrate db:seed db:test:prepare
* Run the tests if you like
  * rspec spec
* Run the app locally
  * rails s
* Visit http://localhost:3000 in your browser
* Login with the same credentials provided in the section above to get access to the admin dashboards
