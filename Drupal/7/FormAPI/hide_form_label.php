<?php

/**
 *  Drupal 7 snippet :
 *  Form API - Hide a label
 */

/**
 *  Implement hook_form_FORM_ID_alter()
 *  → ex: 'comment_form'
 */
function MODULE_OR_THEME_form_comment_form_alter(&$form, &$form_state)
{
    $lang = $form['comment_body']['#language'];
    $form['comment_body'][$lang][0]['#title_display'] = 'invisible';
}

