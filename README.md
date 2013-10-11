# Giffare

I hacked this web application together in a weekend.
Adding to GitHub because there are people who want to contribute.

http://giffare.com

# Running locally

Preconditions: ruby >= 1.9 and postgresql

    git clone git@github.com:tadast/giffare.git
    cd giffare
    bundle
    rake db:create db:migrate db:seed
    GIFLIST_ADMIN_PASSWORD='choose_your_own_password' rails server

To access admin panel go to /gifs/unpublished

# Running tests

    GIFLIST_ADMIN_PASSWORD='secret' bundle exec rspec
