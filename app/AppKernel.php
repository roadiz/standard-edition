<?php
declare(strict_types=1);

use RZ\Roadiz\Core\Kernel;

/**
 * Customize Roadiz kernel with your own project settings.
 */
class AppKernel extends Kernel
{
    /**
     * {@inheritdoc}
     */
    public function getRootDir()
    {
        if (null === $this->rootDir) {
            $r = new \ReflectionObject($this);
            $this->rootDir = dirname($r->getFileName());
        }
        return $this->rootDir;
    }

    /**
     * {@inheritdoc}
     */
    public function getPublicDir()
    {
        return $this->getProjectDir() . '/web';
    }

    /**
     * {@inheritdoc}
     */
    public function getPublicFilesPath(): string
    {
        return $this->getPublicDir() . $this->getPublicFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function getPrivateFilesPath(): string
    {
        return $this->getProjectDir() . $this->getPrivateFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function getFontsFilesPath(): string
    {
        return $this->getProjectDir() . $this->getFontsFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function register(\Pimple\Container $container)
    {
        parent::register($container);

        /*
         * Enable Rozier backoffice
         */
        $container->register(new \Themes\Rozier\Services\RozierServiceProvider());

        /*
         * Add your own service providers.
         */
    }
}
