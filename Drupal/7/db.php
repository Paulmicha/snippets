<?php

/**
 *  DB Queries-related Drupal 7 snippets
 *  @todo rewrite condensed version
 *  
 *  Sources :
 *  https://drupal.org/node/310075
 *  https://drupal.org/node/1848348
 *  http://www.lullabot.com/blog/articles/simplify-your-code-drupal-7s-database-api
 */


/*
Performance note :
https://www.lullabot.com/blog/article/simplify-your-code-drupal-7s-database-api#comment-4530

As catch notes, the Select builder adds a LOT of overhead. YOU SHOULD NOT USE IT UNLESS YOU NEED ONE OF THE THINGS IT OFFERS: Dynamic query structure, hook_query_alter, certain db-unportable features that don't have a simpler version (random ordering, for instance), etc.

For the run of the mill SQL query, db_query() is several times faster than db_select(). If you need a limit query, db_query_range() is still there.

You must use the query builders for non-Select queries, because those are much harder to make portable due to stupidity in many older databases. (Oracle is worst, but Postgres is dumb in places, too.) The actual code you'd have to write for those is vastly different, so the query builders are a necessity. SELECT queries are far more standardized. db_query() is still your friend in many many cases.

Really, db_select() doesn't insulate you from as many db portability issues as you think. It doesn't do anything for SQL functions that differ between databases, doesn't help with date handling, etc. Its primary advantage is what Eaton talks about in this article: When your query structure may change depending on various conditions, it's now dead-simple to do so.

If your query will never change, don't waste the CPU cycles on it. Just write proper ANSI SQL in the first place and it will be sufficiently portable.
*/



//------------------------------------------------------------------------------------------------------------------------------------
//      CRUD


//      @todo list most common snippets :
//          • db_query() and db_query_range() for Select queries
//          • query builders for non-Select queries



//------------------------------------------------------------------------------------------------------------------------------------
//      Select builder Basics


//      Let's say we want to create a dynamic query which is roughly equivalent to the following static query:
$result = db_query("SELECT uid, name, status, created, access FROM {users} u WHERE uid <> 0 LIMIT 50 OFFSET 0");

//      The dynamic equivalent begins as follows:
//      Create an object of type SelectQuery
$query = db_select('users', 'u');
//      Add extra detail to this query object: a condition, fields and a range
$query->condition('u.uid', 0, '<>');
$query->fields('u', array('uid', 'name', 'status', 'created', 'access'));
$query->range(0, 50);

//      Shorthand (chaining) :
$query = db_select('users', 'u')
  ->condition('u.uid', 0, '<>')
  ->fields('u', array('uid', 'name', 'status', 'created', 'access'))
  ->range(0, 50);

//      Once the query is built, call the execute() method to compile and run the query.
$result = $query->execute();
foreach ($result as $record)
{
    //      Do something with each $record
}

//      Fetch :
$result_assoc_arr = $query->execute()->fetchAssoc();

//      Fetch subset :
$result_assoc_arr = $query->range(0, 1)->execute()->fetchAssoc()



//------------------------------------------------------------------------------------------------------------------------------------
//      Select builder Joins


//      To join against another table, use the join(), innerJoin(), leftJoin(), or rightJoin() methods, like so:
$query = db_select('node', 'n');
$table_alias = $query->join('users', 'u', 'n.uid = u.uid AND u.uid = :uid', array(':uid' => 5));

//      The above directive will add an INNER JOIN (the default join type) against the "user" table, which will get an alias of "u".
//      The join will be ON the condition " n.uid = u.uid AND u.uid = :uid", where :uid has a value of 5.
//      Note the use of a prepared statement fragment. That allows for the addition of variable join statements in a secure fashion.

//      The return value of a join method is the alias of the table that was assigned.
//      If an alias is specified it will be used except in the rare case that alias is 

//      Note that in place of a literal such as 'user' for the table name, all of the join methods will accept a select query as their first argument.
//      Example:
$query = db_select('node', 'n');
$myselect = db_select('mytable')
  ->fields('mytable')
  ->condition('myfield', 'myvalue');
$alias = $query->join($myselect, 'myalias', 'n.nid = myalias.nid');

//      Joins cannot be chained, so they have to be called separately (see Chaining). If you are chaining multiple functions together do it like this:
$query = db_select('node', 'n');
$query->join('field_data_body', 'b', 'n.nid = b.entity_id');
$query
  ->fields('n', array('nid', 'title'))
  ->condition('n.type', 'page')
  ->condition('n.status', '1')
  ->orderBy('n.created', 'DESC')
  ->addTag('node_access');




