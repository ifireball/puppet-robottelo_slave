class robottelo_slave::config {

  # Allow cloning of HTTPS based repositories that are using
  # self-signed certificates
  # lint:ignore:quoted_booleans
  git::config { 'http.sslVerify':
    user  => 'jenkins',
    value => 'false',
  }
  # lint:endignore
}
