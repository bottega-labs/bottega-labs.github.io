#!/usr/bin/env ruby
# _data/privacy/*.yml 검사. 언어가 빠진 조항, 채우지 않은 [빈칸], 연결되지 않은 페이지를 막는다.
# 사용: ruby scripts/check-privacy.rb            # 데이터 검사
#       ruby scripts/check-privacy.rb --site _site  # 빌드 결과 검사(조항 수)
require 'yaml'
require 'date'

Encoding.default_external = Encoding::UTF_8

ROOT = File.expand_path('..', __dir__)
I18N_KEYS = %w[privacy_title privacy_effective privacy_date_format].freeze
# Markdown 링크 [text](url)가 아닌 대괄호는 채우지 않은 빈칸으로 본다.
PLACEHOLDER = /\[[^\]\n]*\](?!\()/

def load_yaml(path) = YAML.load_file(path, permitted_classes: [Date])

def front_matter(path)
  text = File.read(path)
  m = text.match(/\A---\n(.*?)\n---\n?(.*)\z/m)
  m ? [YAML.safe_load(m[1]) || {}, m[2]] : [{}, text]
end

errors = []
site_langs = load_yaml(File.join(ROOT, '_config.yml'))['langs'].map { |l| l['code'] }
pages = Dir[File.join(ROOT, '*', 'privacy.html')].to_h { |p| [p, front_matter(p)] }
policies = Dir[File.join(ROOT, '_data', 'privacy', '*.yml')].to_h { |p| [File.basename(p, '.yml'), load_yaml(p)] }

policies.each do |app, p|
  err = ->(msg) { errors << "#{app}: #{msg}" }
  err.('effective must be a date (YYYY-MM-DD)') unless p['effective'].is_a?(Date)
  langs = Array(p['langs'])
  err.('langs is empty') if langs.empty?
  (langs - site_langs).each { |l| err.("lang #{l} is not in _config.yml langs") }
  langs.each do |l|
    i18n_path = File.join(ROOT, '_data', 'i18n', "#{l}.yml")
    missing = File.exist?(i18n_path) ? I18N_KEYS - load_yaml(i18n_path).keys : I18N_KEYS
    err.("_data/i18n/#{l}.yml lacks #{missing.join(', ')}") unless missing.empty?
  end

  sections = Array(p['sections'])
  err.('sections is empty') if sections.empty?
  ids = sections.map { |s| s['id'] }
  ids.tally.each { |id, n| err.("section id #{id.inspect} appears #{n} times") if n > 1 }
  sections.each do |s|
    %w[title body].each do |field|
      langs.each do |l|
        v = s.dig(field, l)
        if !v.is_a?(String) || v.strip.empty?
          err.("#{s['id']}.#{field}.#{l} is missing")
        elsif (hit = v[PLACEHOLDER])
          err.("#{s['id']}.#{field}.#{l} has an unfilled placeholder #{hit}")
        end
      end
      extra = (s[field] || {}).keys - langs
      err.("#{s['id']}.#{field} has #{extra.join(', ')} not listed in langs") unless extra.empty?
    end
  end

  linked = pages.select { |_, (fm, _)| fm['layout'] == 'privacy' && fm['app_id'] == app }
  if linked.empty?
    err.('no <app>/privacy.html with layout: privacy and this app_id')
  else
    linked.each do |path, (_, body)|
      # 데이터가 있으면 레이아웃이 본문을 무시하므로, 남은 본문은 오래된 사본이다.
      err.("#{path.delete_prefix("#{ROOT}/")} still has body content; keep front matter only") unless body.strip.empty?
    end
  end
end

if (i = ARGV.index('--site'))
  site = File.expand_path(ARGV[i + 1] || '_site', ROOT)
  pages.each do |path, (fm, _)|
    app = fm['app_id']
    next unless (p = policies[app])
    built = File.join(site, File.dirname(path).delete_prefix(ROOT), 'privacy.html')
    next errors << "#{app}: #{built} was not built" unless File.exist?(built)
    html = File.read(built)
    want = p['sections'].size * p['langs'].size
    got = html.scan('<h3>').size
    errors << "#{app}: built page has #{got} sections, expected #{want}" unless got == want
    errors << "#{app}: built page has unrendered Liquid" if html.include?('{{') || html.include?('{%')
  end
end

if errors.empty?
  puts "privacy: #{policies.size} policies OK"
else
  warn errors.map { |e| "✗ #{e}" }
  exit 1
end
