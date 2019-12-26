let project = new Project('New Project');
project.addAssets('assets/**', {
    nameBaseDir: 'assets',
    destination: '{dir}/{name}',
    name: '{dir}/{name}'
});
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('zui');
resolve(project);
