package de.tub.citydb.plugin.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.ServiceConfigurationError;
import java.util.ServiceLoader;

import de.tub.citydb.plugin.api.Plugin;
import de.tub.citydb.plugin.api.extension.view.ViewExtension;
import de.tub.citydb.plugin.internal.InternalPlugin;

public class DefaultPluginService implements PluginService {
	private static DefaultPluginService pluginService;	
	private List<InternalPlugin> internalPlugins;
	private List<Plugin> externalPlugins;

	private DefaultPluginService(ClassLoader loader) throws ServiceConfigurationError {
		internalPlugins = new ArrayList<InternalPlugin>();
		externalPlugins = new ArrayList<Plugin>();

		ServiceLoader<Plugin> pluginLoader = ServiceLoader.load(Plugin.class, loader);
		Iterator<Plugin> iter = pluginLoader.iterator();
		while (iter.hasNext())
			externalPlugins.add(iter.next());
	}

	public static synchronized DefaultPluginService getInstance(ClassLoader loader) throws ServiceConfigurationError {
		if (pluginService == null)
			pluginService = new DefaultPluginService(loader);

		return pluginService;
	}

	@Override
	public void registerInternalPlugin(InternalPlugin plugin) {
		internalPlugins.add(plugin);
	}

	@Override
	public List<InternalPlugin> getInternalPlugins() {
		return internalPlugins;
	}

	@Override
	public List<Plugin> getExternalPlugins() {
		return externalPlugins;
	}

	@SuppressWarnings("unchecked")
	@Override
	public <T extends InternalPlugin> T getInternalPlugin(Class<T> pluginClass) {
		for (InternalPlugin plugin : internalPlugins)
			if (pluginClass.isInstance(plugin))
				return (T)plugin;

		return null;
	}

	@Override
	public List<ViewExtension> getExternalViewExtensions(boolean sortByTitle) {
		List<ViewExtension> viewExtensions = new ArrayList<ViewExtension>();
		for (Plugin plugin : externalPlugins) {
			if (plugin instanceof ViewExtension) {
				ViewExtension viewExtension = (ViewExtension)plugin;
				if (viewExtension.getView() != null && viewExtension.getView().getTitle() != null)
					viewExtensions.add((ViewExtension)plugin);
			}
		}

		if (sortByTitle)
			Collections.sort(viewExtensions, new Comparator<ViewExtension>() {
				public int compare(ViewExtension o1, ViewExtension o2) {
					return o1.getView().getTitle().compareTo(o2.getView().getTitle());
				}
			});

		return viewExtensions;
	}

	@Override
	public List<Plugin> getPlugins() {
		List<Plugin> plugins = new ArrayList<Plugin>(internalPlugins);
		plugins.addAll(externalPlugins);

		return plugins;
	}

	@Override
	public void initPlugins() {
		for (Plugin plugin : getPlugins())
			plugin.init();
	}

	@Override
	public void shutdownPlugins() {
		for (Plugin plugin : getPlugins())
			plugin.shutdown();
	} 

}
