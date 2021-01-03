# TitaniumRingsForever.com

This is a flat export of the last stage of the Drupal site for
[TitaniumRingsForever.com](https://titaniumringsforever.com).

## Regeneration

Should the site need to be regenerated, these are the steps:

1. Spin up the [full Drupal
site](https://github.com/exotica-jewelry/archived-ringsforever-pantheon) with
the post-retirement database (archived elsewhere). Note that even though search
is disabled, the site requires Apache Solr and Redis to display category pages.

2. Read through Lullabot's helpful [Sending a Drupal site into
retirement](https://www.lullabot.com/articles/sending-drupal-site-retirement-using-httrack)
blog.

3. Export using [HTTrack](https://www.httrack.com)
(`sudo apt install httrack httrack-doc`). The command used, from the Lullabot
blog, is:

```sh
httrack http://LOCALSITE -O OUTPUTDIR -N %h%p/%n/index%[page].%t -WqQ%v -s0 -%F ""
```

4. `cd` into the output folder and run:

```sh
find . -name "*.html" -type f -print0 |   xargs -0 perl -i -pe "s/\/index.html/\//g"
```

to fix links to individual `index.html` files.

5. Find and replace all links to `../index.html`, `../../index.html`, and
`../../../index.html` with `/`, i.e. the home page. Note this must be done
after the step above!

6. Search for files that contain the text "Page has moved" or "No results" and
redirect or remove these.

7. Search and replace the default Search API meta description tag of:

```
Display all the products that are available, using Search API
```

with:

```
Our catalog of handcrafted titanium wedding rings.
```

8. Search and remove the following two meta tags which are no longer valid:

```
<link rel="canonical" href="index.html" />
```

```
 <link rel="shortlink" href="index.html" />
```

9. Push the site up and, once rebuilt, run it through a link checker to make
sure there are no broken links. Also check links to the home page (the "home"
tab and the logo) from various pages such as category pages, ring pages, the
blog index and blog entries, and "about" pages, to ensure these were correctly
fixed in step 5 above.

10. Do a quick sanity check to make sure things like images are loading on
category pages, ring pages, the blog index and blog entries, and "about" pages.
