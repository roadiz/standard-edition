<?php
declare(strict_types=1);

/**
 * Customize Roadiz kernel with your own project settings for development.
 */
class DevAppKernel extends AppKernel
{
    private string $appName;

    /**
     * @param string $environment
     * @param bool $debug
     * @param bool $preview
     * @param string $appName
     */
    public function __construct(string $environment, bool $debug, bool $preview = false, string $appName = "roadiz_dev")
    {
        parent::__construct($environment, $debug, $preview);
        $this->appName = $appName;
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
