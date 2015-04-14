<?php

/**
 *  Drupal 7 API snippet - Entity Metadata Wrappers
 *  
 *  Sources :
 *  https://www.drupal.org/documentation/entity-metadata-wrappers
 *  http://www.pixelite.co.nz/article/how-use-entity-metadata-wrappers-drupal-7
 *  http://www.mediacurrent.com/blog/entity-metadata-wrapper
 */


//------------------------------------------------------------
//      Init


//      Unnecessary node load
$node = node_load($nid);
$wrapper = entity_metadata_wrapper('node', $node);

//      More efficient (if the object isn't handed to you)
$wrapper = entity_metadata_wrapper('node', $nid);



//------------------------------------------------------------
//      Fetch


//      Any value
$node_wrapper->field_foobar->value();
$first_name = $wrapper->field_tags[0]->name->value();

//      Unified way of getting $node->title, $user->name, ...
$wrapper->label();

//      Unified way of getting $node->nid, $user->uid, ...
$wrapper->getIdentifier();

//      Unified way of getting $node->type, ...
$wrapper->getBundle();

//      Meta
$mail_info = $wrapper->author->mail->info();

//      Other examples
$wrapper->body->raw();
$wrapper->title->value(array('sanitize' => TRUE));
$wrapper->body->value->value(array('decode' => TRUE));



//------------------------------------------------------------
//      Iterate with "auto" Chaining


foreach ($wrapper->field_taxonomy_terms->getIterator() as $delta => $term_wrapper)
{
    //  $term_wrapper may now be accessed as a taxonomy term wrapper.
    $label = $term_wrapper->label->value();
}



//------------------------------------------------------------
//      Create / Update / Delete


//      Set
$wrapper->author->mail = 'sepp@example.com';

//      Set several values at once
$nids_to_set = array(42, 23);
$w_containing_node->field_entity_reference_field->set($nids_to_set);

//      Appending
$w_containing_node->field_entity_reference_field[] = 42;
$w_containing_node->field_entity_reference_field[] = 23;

//      Remove value
$wrapper->field_foobar = NULL;
//      or just 1 vlue of a multi-valued field :
unset($wrapper->field_data[$delta]);

//      Field Collection : setHostEntity()
$collection = entity_create('field_collection_item', array('field_name' => 'field_facilities_requested'));
$collection->setHostEntity('node', $node);

//      Save changes to entity
$wrapper->save();

//      Delete entity
$wrapper->delete();



//------------------------------------------------------------
//      Error handling


try
{
    $node_wrapper = entity_metadata_wrapper('node', $node);
    $price = $node_wrapper->field_product->field_price->value();
} 
catch (EntityMetadataWrapperException $exc)
{
    watchdog(
        'MODULE_NAME',  
        'See '  . __FUNCTION__ . '() <pre>' .  $exc->getTraceAsString() . '</pre>', 
        NULL,
        WATCHDOG_ERROR
    );
}


