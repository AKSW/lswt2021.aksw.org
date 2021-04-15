This is the Source for the LSWT2021: https://lswt2021.aksw.org/

To prepare the Java Script
```
npm install
npx webpack
```

For the Ruby/Jekyll/Jekyll RDF environment
```
bundle install --path .vendor
bundle exec jekyll serve
# or
bundle exec jekyll build
```

To rebuild:

```
npx webpack
bundle exec jekyll serve
# or
bundle exec jekyll build
```

For travis setup see: https://docs.travis-ci.com/user/deployment/pages/
