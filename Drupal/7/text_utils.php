<?php

/**
 *  Text-related Drupal 7 snippets
 */

//  String placeholders :
//  format_string($string, array $args = array())
//      @variable: Escaped to HTML using check_plain(). Use this as the default choice for anything displayed on a page on the site.
//      %variable: Escaped to HTML and formatted using drupal_placeholder(), which makes it display as <em>emphasized</em> text.
//      !variable: Inserted as is, with no sanitization or formatting. Only use this for text that has already been prepared for HTML display (for example, user-supplied text that has already been run through check_plain() previously, or is expected to contain some limited HTML tags and has already been run through filter_xss() previously).
//  Examples with t() :
$i10n_dynamic_string = t("There is @check_plain.", array('@check_plain' => "no HTML here"));
$i10n_dynamic_string = t("There is %wrapped_in_em_tags.", array('%wrapped_in_em_tags' => "no HTML here either"));
$i10n_dynamic_string = t("There is !unfiltered.", array(
  // Security consideration example.
  '!unfiltered' => filter_xss("a raw, unfiltered string <strong class='foo'>with HTML</strong>.")
));

//  I10n string formatter : singular / plural
//  format_plural($count, $singular, $plural, array $args = array(), array $options = array())
//  @see https://api.drupal.org/api/drupal/includes%21common.inc/function/format_plural/7
$count = 3;
$output = format_plural($count, '1 item', '@count items');

//  Example with additional arguments :
$output = format_plural(
  $count,
  'Changed the content type of 1 post from %old-type to %new-type.',
  'Changed the content type of @count posts from %old-type to %new-type.',
  array(
    '%old-type' => $info->old_type,
    '%new-type' => $info->new_type,
  )
);
