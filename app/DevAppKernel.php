<?php
/**
 * Class DevAppKernel.
 *
 * Customize Roadiz kernel with your own project settings for development.
 */

class DevAppKernel extends AppKernel
{
    /**
     * @var string
     */
    private $appName;

    /**
     * @param string $environment
     * @param boolean $debug
     * @param bool $preview
     * @param string $appName
     */
    public function __construct($environment, $debug, $preview = false, $appName = "roadiz_dev")
    {
        parent::__construct($environment, $debug, $preview);

        $this->appName = $appName;
    }

    /**
     * @param string $environment
     * @param bool $debug
     * @param bool $preview
     * @param string $appName
     * @return null
     */
    public static function getInstance($environment = 'dev', $debug = true, $preview = false, $appName = "roadiz_dev")
    {
        if (static::$instance === null) {
            static::$instance = new static($environment, $debug, $preview, $appName);
        }
        return static::$instance;
    }

    /**
     * It’s important to set cache dir outside of any shared folder. RAM disk is a good idea.
     *
     * @return string
     */
    public function getCacheDir()
    {
        return '/dev/shm/' . $this->appName . '/cache/' .  $this->environment;
    }

    /**
     * It’s important to set logs dir outside of any shared folder. RAM disk is a good idea.
     *
     * @return string
     */
    public function getLogDir()
    {
        return '/dev/shm/' . $this->appName . '/logs';
    }
}