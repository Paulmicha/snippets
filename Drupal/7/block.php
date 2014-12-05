<?php

/**
 *  Blocks-related Drupal 7 snippets
 *  
 *  sources :
 *  http://www.only10types.com/2012/05/drupal-7-render-block-in-template-file.html
 *  http://drupal.stackexchange.com/questions/5775/programmatically-printing-a-block
 *  https://www.drupal.org/node/957038
 */


//  ex : module_invoke('system', 'block_view', 'navigation');
$block = module_invoke('MODULE_NAME', 'block_view', 'BLOCK_ID');
$html = drupal_render($block);


//      @see https://www.drupal.org/node/957038
//      @see http://www.only10types.com/2012/05/drupal-7-render-block-in-template-file.html
$block = block_load($module, $block_id);
$block_content = _block_render_blocks(array($block));
$build = _block_get_renderable_array($block_content);
$block_rendered = drupal_render($build);


//      One-liner example :
$html_output = drupal_render(_block_get_renderable_array(_block_render_blocks(array(block_load('block', '1')))));


//      Custom blocks
$block = block_custom_block_get(1);
$content = $block['body'];

