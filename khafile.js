let project = new Project('Paddy-Editor');
project.addAssets('assets/**', {
    nameBaseDir: 'assets',
    destination: '{dir}/{name}',
    name: '{dir}/{name}'
});
project.addSources('Sources');
project.addLibrary('zui');
resolve(project);
