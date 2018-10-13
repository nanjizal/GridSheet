let project = new Project('drawSubImage Test');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('src');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve( project );