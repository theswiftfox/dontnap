project('DontNap', 'vala', 'c', version: '1.0.0')

i18n = import('i18n')
gettext_name = meson.project_name() + '-indicator'

prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(gettext_name), language:'c')

libwingpanel_dep = dependency('wingpanel-2.0')
indicators_dir = libwingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

shared_module('dontnap-indicator',
    'src/DontNapIndicator.vala',
    dependencies: libwingpanel_dep,
    install: true,
    install_dir: indicators_dir
)
