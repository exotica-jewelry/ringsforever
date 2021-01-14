# TitaniumRingsForever.com

This is a flat export of the last stage of the Drupal site for
[TitaniumRingsForever.com](https://titaniumringsforever.com).

<!-- The following section, from "ts" to "te", is an automatically-generated
  table of contents, updated whenever this file changes. Do not edit within
  this section. -->

<!--ts-->
   * [TitaniumRingsForever.com](#titaniumringsforevercom)
      * [Regeneration](#regeneration)
      * [Theming changes](#theming-changes)
         * [CSS](#css)
         * [HTML](#html)
         * [JS](#js)

<!-- Added by: runner, at: Thu Jan 14 03:09:42 UTC 2021 -->

<!--te-->

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
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/\/index.html/\//g"
```

to fix links to individual `index.html` files.

5. Fix links to the home page -- note that this must be done after the step
above!

```sh
find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/..\/index.html/\//g' && find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/..\/..\/index.html/\//g' && find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/..\/..\/..\/index.html/\//g'
```

6. Search for files that contain the text "Page has moved" or "No results" and
redirect or remove these.

7. Replace the default Search API meta description tag:

```sh
find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/Display all the products that are available, using Search API/Our catalog of handcrafted titanium wedding rings./g'
```

8. Remove two meta tags which are no longer valid:

```sh
find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/<link rel="canonical" href="index.html" \/>//g' && find . -name "*.html" -type f -print0 | xargs -0 sed -i 's/<link rel="shortlink" href="index.html" \/>//g'
```

9. Copy over all the contents of `site/default/files/styles` directories from
the original Drupal files backups, since these files will not all be caught by
HTTrack. Consult the HTTrack-generated file `sites/default/files/skipped.log` to
see a (likely incomplete) list of these files. `cd` into each image directory
and run:

```sh
../../../../../../../_scripts/move-images.sh
```

10. Update references to these files by searching and replacing with the
following [regex](https://regex101.com/) patterns:

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/\(frontpage_block\)\/public\/rings\/\([^\/]*?\)\.jpg/$1\/public\/rings\/$2\/index\.jpg/g"
```

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/\(product_full\)\/public\/rings\/\([^\/]*?\)\.jpg/$1\/public\/rings\/$2\/index\.jpg/g"
```

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/\(product_medium\)\/public\/rings\/\([^\/]*?\)\.jpg/$1\/public\/rings\/$2\/index\.jpg/g"
```

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/\(product_thumbnail\)\/public\/rings\/\([^\/]*?\)\.jpg/$1\/public\/rings\/$2\/index\.jpg/g"
```

Notes: `product_zoom` references do not need to be updated, because they will
not have been changed by HTTrack in the first place. You may also want to do a
sanity check and ensure that no references like `index/index.jpg` have been
created.

11. Fix lazyloading by running:

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/src=\"sites\/all\/themes\/lazyloader-image-placeholder\/\"/src=\"data:image\/gif;base64,R0lGODlhAQABAIAAAAAAAP\/\/\/yH5BAEAAAAALAAAAAABAAEAAAIBRAA7\"/g" && find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/src=\"\.\.\/sites\/all\/themes\/lazyloader-image-placeholder\/\"/src=\"data:image\/gif;base64,R0lGODlhAQABAIAAAAAAAP\/\/\/yH5BAEAAAAALAAAAAABAAEAAAIBRAA7\"/g" && find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/src=\"\.\.\/\.\.\/sites\/all\/themes\/lazyloader-image-placeholder\/\"/src=\"data:image\/gif;base64,R0lGODlhAQABAIAAAAAAAP\/\/\/yH5BAEAAAAALAAAAAABAAEAAAIBRAA7\"/g" && find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/src=\"\.\.\/\.\.\/\.\.\/sites\/all\/themes\/lazyloader-image-placeholder\/\"/src=\"data:image\/gif;base64,R0lGODlhAQABAIAAAAAAAP\/\/\/yH5BAEAAAAALAAAAAABAAEAAAIBRAA7\"/g" && find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/src=\"\.\.\/\.\.\/\.\.\/\.\.\/sites\/all\/themes\/lazyloader-image-placeholder\/\"/src=\"data:image\/gif;base64,R0lGODlhAQABAIAAAAAAAP\/\/\/yH5BAEAAAAALAAAAAABAAEAAAIBRAA7\"/g"
```

12. Fix the home page logo:

```sh
find . -name "*.html" -type f -print0 | xargs -0 perl -i -pe "s/sites\/default\/files\/exologo2010\.jpg/sites\/default\/files\/exologo2010\/index.jpg/g"
```

13. Push the site up and, once rebuilt, run it through a link checker to make
sure there are no broken links. Also check links to the home page (the "home"
tab and the logo) from various pages such as category pages, ring pages, the
blog index and blog entries, and "about" pages, to ensure these were correctly
fixed in step 5 above.

14. Do a quick sanity check to make sure things like images are loading on
category pages, ring pages, the blog index and blog entries, and "about" pages.

15. Ensure that HTTPS is still working properly.

## GitHub Actions

Several [Actions](https://docs.github.com/en/free-pro-team@latest/actions) are implemented.

## Theming changes

All CSS, HTML and JS theming changes should be recorded here as a list of
commits, since if the site is exported again they may be overlooked.

### CSS
- https://github.com/exotica-jewelry/ringsforever/commit/5ff19fead40dde04260270b904c16e1686a3bede
- https://github.com/exotica-jewelry/ringsforever/commit/89813b1c631970de1799981400063d494d876a94
- https://github.com/exotica-jewelry/ringsforever/commit/d5935e451361fd2e4000ed2b2d95604b56a189b1

### HTML
- https://github.com/exotica-jewelry/ringsforever/commit/15e3cb007a3bf22f4efd59b5382ea2b39b1f25d6
- https://github.com/exotica-jewelry/ringsforever/commit/f8424387af80151bd89e0b37f80c51c163e065e7
- https://github.com/exotica-jewelry/ringsforever/commit/2594bd83a9b4193fc6ad8e5fc0c1f49290226de5
- https://github.com/exotica-jewelry/ringsforever/commit/4e8dbf5f6066d3de0deefe74bed555a44f39415f
- https://github.com/exotica-jewelry/ringsforever/commit/cfb4c4d716b3721aede9eeb203d4fd978f19cf3a
- https://github.com/exotica-jewelry/ringsforever/commit/94b62438cf3fbab18975bfc85dbea6df3f3effce
- https://github.com/exotica-jewelry/ringsforever/commit/17f531c076606b76d8d77c31034f99addf0636bc
- https://github.com/exotica-jewelry/ringsforever/commit/b3279a0b72be6281a4767da6c97b4776772112a3
- https://github.com/exotica-jewelry/ringsforever/commit/6904aa7e4f3d712aef55e3359b19131551b130af

### JS

- None so far.