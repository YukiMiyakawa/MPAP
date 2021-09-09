# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin.create!(
#   email: "admin@admin.com",
#   password: "admin1234",
#   )

# Instrument.create!([
#   {name: 'ボーカル'},{name: 'ギター'},{name: 'ベース'},{name: 'ピアノ・キーボード'},{name: 'ドラム'},
#   {name: 'パーカッション'},{name: '管楽器'},{name: '弦楽器'},{name: 'その他'}
#   ])

MusicGenre.create!([
  {name: 'ポップス'},{name: 'ロック'},{name: 'ハードロック/ヘビーメタル'},{name: 'パンク/メロコア'},{name: 'スラッシュメタル/デスメタル'},
  {name: 'ビジュアル系'},{name: 'ファンク/ブルース'},{name: 'ジャズ/フュージョン'},{name: 'カントリー/フォーク'},{name: 'スカ/ロカビリー'},
  {name: 'ソウル/R&B'},{name: 'ゴスペル/アカペラ'},{name: 'ボサノバ/ラテン'},{name: 'クラシック'},{name: 'ヒップホップ/レゲエ'},{name: 'ハウス/テクノ'},
  {name: 'アニソン/ボカロ'},{name: 'その他'}
  ])