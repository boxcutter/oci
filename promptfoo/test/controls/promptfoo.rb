describe command('node --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/v24/) }
end

describe command('promptfoo --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/\d+\.\d+\.\d+/) }
end

describe command('pf --version') do
  its('exit_status') { should eq 0 }
end

describe file('/opt/promptfoo/node_modules/promptfoo/dist/src/server/index.js') do
  it { should exist }
end

describe command('python --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Python 3/) }
end

describe command('pip3 --version') do
  its('exit_status') { should eq 0 }
end

describe user('promptfoo') do
  it { should exist }
  its('uid') { should eq 1000 }
  its('gid') { should eq 1000 }
end

describe directory('/home/promptfoo/.promptfoo') do
  it { should exist }
  its('owner') { should eq 'promptfoo' }
end

describe os_env('PROMPTFOO_SELF_HOSTED') do
  its('content') { should eq '1' }
end

describe os_env('API_PORT') do
  its('content') { should eq '3000' }
end

# Run an eval end to end with the offline echo provider. Saving the result
# loads the native libsql module, so a missing or broken prebuilt binary
# fails here.
describe command(<<~'SH') do
  set -e
  dir="$(mktemp -d)"
  cd "${dir}"
  cat > promptfooconfig.yaml <<'EOF'
  prompts: ["Say {{word}}"]
  providers: [echo]
  tests:
    - vars: {word: hello}
      assert: [{type: contains, value: hello}]
  EOF
  promptfoo eval --no-progress-bar
  promptfoo list evals
SH
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/1 passed/) }
end

# Start the web server the same way the image's CMD does and wait for
# /health to answer.
describe command(<<~'SH') do
  node /opt/promptfoo/node_modules/promptfoo/dist/src/server/index.js > /tmp/server.log 2>&1 &
  pid=$!
  rc=1
  for _ in $(seq 1 30); do
    if curl -fsS http://127.0.0.1:3000/health; then
      rc=0
      break
    fi
    sleep 1
  done
  kill "${pid}"
  [ "${rc}" -eq 0 ] || cat /tmp/server.log
  exit "${rc}"
SH
  its('exit_status') { should eq 0 }
end
