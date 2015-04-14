<?php

/**
 *  Drupal 7 - Field API snippets
 *  
 *  Sources :
 *  http://www.computerminds.co.uk/articles/rendering-drupal-7-fields-right-way
 *  http://stackoverflow.com/questions/11694770/print-drupal-field-view-field-value-only
 */



//--------------------------------------------
//  Getting items


//  Get item(s) - Term entity ex.
$term = taxonomy_term_load($tid);
$field_images_items = field_get_items('taxonomy_term', $term, 'field_images');
$field_sub_title_item = @reset(field_get_items('taxonomy_term', $term, 'field_sub_title'));

//  Get item(s) - Node entity ex.
$node = menu_get_object();
$field_images_items = field_get_items('node', $node, 'field_images');
$field_sub_title_item = @reset(field_get_items('node', $node, 'field_sub_title'));

//  Get item(s) - User entity ex.
$field_name_item = @reset(field_get_items('user', $account, 'field_name'));



//--------------------------------------------
//  Getting values
//  NB: the key may vary


//  Example with 'value' :
$field_description_item = @reset(field_get_items('node', $node, 'field_description'));
$description = $field_description_item['value'];



//--------------------------------------------
//  Rendering


//  Render a single field value
$field = field_get_items('node', $node, 'field_name');
$output = field_view_value('node', $node, 'field_name', $field[$delta]);

//  Using drupal_render()
//  $field will be an array with the following keys : #theme, #weight, #title, #access, #label_display, #view_mode, #language, #field_name, #field_type, #field_translatable, #entity_type, #bundle, #object, #items, #formatter, 0
//  where #items will have the values
//  ex: $field['#items'][0]['whatever_field_data']
//  Note : http://stackoverflow.com/questions/11694770/print-drupal-field-view-field-value-only
//  field_view_value() takes a $display argument that you can use to hide the label:
$display = array('label' => 'hidden');
$view = field_view_field('node', $node, 'field_description', $display);
print drupal_render($view);

//  The column name ($first_item['whatever']) will depend on the type of field you're using. For text fields it will be value. Remember to sanitise the input with check_plain() before you output it as Drupal's convention is to store the raw input data and sanitise it upon output.

//  Get sanitised rendered field in the current language in render-array form
$field = field_view_field('node', $node, 'field_name');

