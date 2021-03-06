class Notifier < ActionMailer::Base
  default from: "contato@nossascidades.org"
  layout "mail"

  def new_spreader campaign_spreader
    @user = campaign_spreader.timeline.user
    @campaign = campaign_spreader.campaign
    @organization = @campaign.organization
    mail(
      to: @user.email,
      subject: "Parabéns, você acaba de dar voz a um Compartilhaço!",
      from: "#{@campaign.user.name} <#{@campaign.user.email}>"
    )
  end

  def new_spam_report spam_report
    @user = spam_report.user
    @campaign = spam_report.campaign
    mail(
      to: ENV["TECH_TEAM_EMAIL"],
      subject: "[Compartilhaço] Nova denúncia",
      from: "#{@user.name} <#{@user.email}>"
    )
  end

  def new_campaign campaign
    @campaign = campaign
    @user = campaign.user
    @organization = campaign.organization
    mail(
      to: @user.email,
      subject: "Que legal, seu Compartilhaço foi criado com sucesso!"
    )
  end

  def unsucceed_campaign_to_spreaders campaign, user
    @campaign = campaign
    @organization = campaign.organization
    @user = user
    mail(
      to: @user.email,
      subject: "Que pena, o Compartilhaço que você apoiou não bateu sua meta de disparo!"
    )
  end

  def unsucceed_campaign_to_creator campaign
    @campaign = campaign
    @user = campaign.user
    @organization = campaign.organization
    mail(
      to: @user.email,
      subject: "Que pena, seu Compartilhaço não bateu sua meta de disparo!"
    )
  end

  def succeed_campaign_to_spreaders campaign, user
    @campaign = campaign
    @organization = campaign.organization
    @user = user
    mail(
      to: @user.email,
      subject: "Ueba, o Compartilhaço que você apoiou foi disparado!"
    )
  end

  def succeed_campaign_to_creator campaign
    @campaign = campaign
    @user = campaign.user
    @organization = campaign.organization
    mail(
      to: @user.email,
      subject: "Ueba, o Compartilhaço que você criou foi disparado!"
    )
  end

  def expiring_campaign_to_creator campaign
    @campaign = campaign
    @user = campaign.user
    @organization = campaign.organization
    mail(
      to: @user.email,
      subject: "Força, faltam 3 dias e seu Compartilhaço ainda precisa de mais perfis emprestados!"
    )
  end
end
