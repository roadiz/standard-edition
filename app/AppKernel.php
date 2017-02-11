<?php
/**
 * Class AppKernel.
 *
 * Customize Roadiz kernel with your own project settings.
 */

class AppKernel extends \RZ\Roadiz\Core\Kernel
{
    /**
     * {@inheritdoc}
     */
    public function getRootDir()
    {
        return ROADIZ_ROOT . '/app';
    }

    /**
     * {@inheritdoc}
     */
    public function getVendorDir()
    {
        return ROADIZ_ROOT . '/vendor';
    }

    /**
     * {@inheritdoc}
     */
    public function getPublicDir()
    {
        return ROADIZ_ROOT . '/web';
    }

    /**
     * {@inheritdoc}
     */
    public function getPublicFilesPath()
    {
        return $this->getPublicDir() . $this->getPublicFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function getPrivateFilesPath()
    {
        return ROADIZ_ROOT . $this->getPrivateFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function getFontsFilesPath()
    {
        return ROADIZ_ROOT . $this->getFontsFilesBasePath();
    }

    /**
     * {@inheritdoc}
     */
    public function initEvents()
    {
        parent::initEvents();

        /*
         * Add your subscribers and listeners.
         */
    }

    /**
     * {@inheritdoc}
     */
    public function register(\Pimple\Container $container)
    {
        parent::register($container);

        /*
         * Add your own service providers.
         */
    }
}