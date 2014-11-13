class setup($revision) {
  $dir = '/tmp/testing_vcsrepo_sanbox'
  
  file { $dir :
    ensure => directory,
  }
  
# this always fails
#   vcsrepo { "${dir}/test_with_no_revision" :
#     ensure   => latest,
#     source   => 'https://github.com/rubyisbeautiful/testing_vcsrepo.git',
#     provider => git,
#     require  => File[$dir],
#   }

  notify { "${dir}/test_hardcoded_revision" :
    message => "this never fails",
  } ->
  vcsrepo { "${dir}/test_hardcoded_revision" :
    ensure   => latest,
    source   => 'https://github.com/rubyisbeautiful/testing_vcsrepo.git',
    provider => git,
    revision => 'master',
    require  => File[$dir],
  }

  notify { "${dir}/test_hardcoded_revision" :
    message => "this never fails",
  } ->
  vcsrepo { "${dir}/test_variable_revision" :
    ensure   => latest,
    source   => 'https://github.com/rubyisbeautiful/testing_vcsrepo.git',
    provider => git,
    revision => $revision,
    require  => File[$dir],
  }

  notify { "${dir}/test_hardcoded_revision" :
    message => "this fails sometimes on other systems, when path is specified
     and it is different than the vcsrepo title",
  } ->
  vcsrepo { "some name with path" :
    ensure   => latest,
    source   => 'https://github.com/rubyisbeautiful/testing_vcsrepo.git',
    path     => "${dir}/some_name_with_path",
    provider => git,
    revision => $revision,
    require  => File[$dir],
  }

}

include setup

