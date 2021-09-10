run "mv #{config.release_path}/uploads #{config.release_path}/uploads.old" 

 run "ln -nfs #{config.shared_path}/uploads #{config.release_path}/uploads" 

