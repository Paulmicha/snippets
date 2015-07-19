<?php

/**
 *  Php minimal Git Deployment - Drupal variant
 *  using Bitbucket's post-commit hook
 *  
 *  Sources :
 *  https://gist.github.com/EvaldasUzkuras/5928663
 *  https://gist.github.com/krisnoble/4692643
 *  http://simianstudios.com/blog/post/using-bitbucket-for-automated-deployment-of-multiple-repositories
 *  http://brandonsummers.name/blog/2012/02/10/using-bitbucket-for-automated-deployments/
 */

date_default_timezone_set('Europe/Vilnius'); // Set this to your local timezone - http://www.php.net/manual/en/timezones.php

/**
* The root directory where the repos live.
* 
* @var string
*/
$root_dir = '/your/root/dir/';
  
/**
* A list of repo slugs that the script is allowed to know about, and their
* locations relative to $root_dir.
* 
* @var array
*/
$repos = array(
  'repo-slug' => 'repo_location'
);

class Deploy {
  /**
  * A callback function to call after the deploy has finished.
  * 
  * @var callback
  */
  public $post_deploy;
  
  /**
  * The name of the file that will be used for logging deployments. Set to 
  * FALSE to disable logging.
  * 
  * @var string
  */
  private $_log = '/your/log/dir/deploy.log';

  /**
  * The timestamp format used for logging.
  * 
  * @link    http://www.php.net/manual/en/function.date.php
  * @var     string
  */
  private $_date_format = 'Y-m-d H:i:sP';

  /**
  * The name of the branch to pull from.
  * 
  * @var string
  */
  private $_branch = 'master';

  /**
  * The name of the remote to pull from.
  * 
  * @var string
  */
  private $_remote = 'origin';

  /**
  * The directory where your website and git repository are located, can be 
  * a relative or absolute path
  * 
  * @var string
  */
  private $_directory;

  /**
  * Sets up defaults.
  * 
  * @param  string  $directory  Directory where your website is located
  * @param  array   $data       Information about the deployment
  */
  public function __construct($directory, $options = array())
  {
      // Determine the directory path
      $this->_directory = realpath($directory).DIRECTORY_SEPARATOR;

      $available_options = array('log', 'date_format', 'branch', 'remote');

      foreach ($options as $option => $value)
      {
          if (in_array($option, $available_options))
          {
              $this->{'_'.$option} = $value;
          }
      }

      $this->log('Attempting deployment...');
  }

  /**
  * Writes a message to the log file.
  * 
  * @param  string  $message  The message to write
  * @param  string  $type     The type of log message (e.g. INFO, DEBUG, ERROR, etc.)
  */
  public function log($message, $type = 'INFO')
  {
      echo $message;
      if ($this->_log)
      {
          // Set the name of the log file
          $filename = $this->_log;

          if ( ! file_exists($filename))
          {
              // Create the log file
              file_put_contents($filename, '');

              // Allow anyone to write to log files
              chmod($filename, 0666);
          }

          // Write the message into the log file
          // Format: time --- type: message
          file_put_contents($filename, date($this->_date_format).' --- '.$type.': '.$message.PHP_EOL, FILE_APPEND);
      }
  }

  /**
  * Executes the necessary commands to deploy the website.
  */
  public function execute()
  {
      try
      {
          // Make sure we're in the right directory
          chdir($this->_directory);
          $this->log('Changing working directory... ');

          // Discard any changes to tracked files since our last deploy
          exec('git reset --hard HEAD', $output);
          $this->log('Reseting repository... '.implode(' ', $output));

          // Update the local repository
          exec('git pull '.$this->_remote.' '.$this->_branch, $output);
          $this->log('Pulling in changes... '.implode(' ', $output));

          // Secure the .git directory
          exec('chmod -R og-rx .git');
          $this->log('Securing .git directory... ');

	  // Update Drupal database
          $output = '';
          exec('drush updb --debug -y', $output);
          $this->log('Updating... '.implode(' ', $output));

	  // Clear all cache
          $output = '';
          exec('drush cc all', $output);
          $this->log('Clearing cache... '.implode(' ', $output));

    	  // Revert all Features
          $output = '';
          exec('drush fra --yes', $output);
          $this->log('Reverting features... '.implode(' ', $output));

          if (is_callable($this->post_deploy))
          {
              call_user_func($this->post_deploy, $this->_data);
          }

          $this->log('Deployment successful.');
      }
      catch (Exception $e)
      {
          $this->log($e, 'ERROR');
      }
  }

}

// This is where the magic happens
$slug = $_POST['repository']['slug'];

if($slug == '') { // check in the 'payload' param if the data isn't in the post body itself
	$post_data = json_decode(stripslashes($_POST['payload']), TRUE);
	$slug = $post_data['repository']['slug'];
}

if(array_key_exists($slug, $repos))
{
	$deploy = new Deploy($root_dir . $repos[$slug]);
	$deploy->execute();
}
elseif($slug == '')
{
	die('No repo specified.');
}
else
{
	die('Repo "' . $slug . '" has not been set up in the deploy script.');
}

?>