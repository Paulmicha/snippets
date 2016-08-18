<?php

/**
 * Dependency injection notes.
 *  
 * Source :
 * https://www.computerminds.co.uk/drupal-code/dependency-injection-how-access-services-controllers
 */

// Class constructor :
public static function create(ContainerInterface $container) {
  return new static(
    $container->get('foo.bar')
  );
}

// Class dependencies :
use Drupal\MyCustomModule\FooBar;
use Symfony\Component\DependencyInjection\ContainerInterface;

// For the controller to be called correctly it must either :
// • implement ContainerInjectionInterface
// • or extend ControllerBase (because that class implements ContainerInjectionInterface)
class MyCustomController implements ContainerInjectionInterface {

// Usage :
$data = $this->fooBar->getData();
