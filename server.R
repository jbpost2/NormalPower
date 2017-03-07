library(shiny)

# Define server logic required to draw the plots etc
shinyServer(function(input, output,session) {
 
  output$powerPicPlot<-renderPlot({
    #get inputs
    mu0<-input$mu0
    n<-input$sampleSize
    se<-input$sigma/sqrt(n)
    muA<-input$muA
    alternative<-input$HA
    alpha<-input$alpha
    
    #plotting sequence
    x<-seq(from=min(mu0-4*se,muA-4*se),to=max(mu0+4*se,muA+4*se),length=10000)

    ##############################################
    ##Graph of null distribution
    plot(x=x,y=dnorm(x,mean=mu0,sd=se),type='l',col="blue",xaxt="n",ylab="f(z)",lwd=3,xlab="Sample mean values",main="Distribution of Y-bar under H0 and HA")
    axis(side=1)
    #all alternative
    lines(x=x,y=dnorm(x,mean=muA,sd=se),type='l',col="red",lwd=3)
    
    if (alternative=="Greater Than"){    
      #add in rejection region, reject for y-bar > z_alpha * sigma/sqrt(n)+mu_0
      mtext("|rejection region---->",side=1,at=qnorm(1-alpha)*se+mu0,adj=0)
      #Shade in RR
      shortseq<-seq(from=qnorm(1-alpha)*se+mu0,to= max(x),length=1000)
      polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=mu0,sd=se))),col=rgb(160,160,160,40,maxColorValue = 255))

      #put in probability of a type II error
      shortseq2<-seq(from=min(x),to=qnorm(1-alpha)*se+mu0,length=1000)
      polygon(c(shortseq2,rev(shortseq2)),c(rep(0,length(shortseq2)),rev(dnorm(shortseq2,mean=muA,sd=se))),col=rgb(255,255,0,80,maxColorValue = 255))
    } else if (alternative=="Less Than"){
      #add in rejection region, reject for y-bar < (z_1-alpha * sigma/sqrt(n)+mu_0
      mtext("<----rejection region|",side=1,at=qnorm(alpha)*se+mu0,adj=1)
      #Shade in RR
      shortseq<-seq(from=min(x), to=qnorm(alpha)*se+mu0,length=1000)
      polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=mu0,sd=se))),col=rgb(160,160,160,40,maxColorValue = 255))
      
      #put in probability of a type II error
      shortseq2<-seq(from=qnorm(alpha)*se+mu0,to=max(x),length=1000)
      polygon(c(shortseq2,rev(shortseq2)),c(rep(0,length(shortseq2)),rev(dnorm(shortseq2,mean=muA,sd=se))),col=rgb(255,255,0,80,maxColorValue = 255))
  } else if (alternative=="Not Equal"){
    #add in rejection region, reject for |y-bar| > z_alpha/2 * sigma/sqrt(n)+mu_0
    mtext("<----rejection region|",side=1,at=qnorm(alpha/2)*se+mu0,adj=1)
    mtext("|rejection region---->",side=1,at=qnorm(1-alpha/2)*se+mu0,adj=0)
    
    #Shade in RR
    shortseq<-seq(from=min(x), to=qnorm(alpha/2)*se+mu0,length=1000)
    polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=mu0,sd=se))),col=rgb(160,160,160,40,maxColorValue = 255))
    shortseq<-seq(from=qnorm(1-alpha/2)*se+mu0,to= max(x),length=1000)
    polygon(c(shortseq,rev(shortseq)),c(rep(0,length(shortseq)),rev(dnorm(shortseq,mean=mu0,sd=se))),col=rgb(160,160,160,40,maxColorValue = 255))
    
    #put in probability of a type II error
    shortseq2<-seq(from=qnorm(alpha/2)*se+mu0,to=qnorm(1-alpha/2)*se+mu0,length=1000)
    polygon(c(shortseq2,rev(shortseq2)),c(rep(0,length(shortseq2)),rev(dnorm(shortseq2,mean=muA,sd=se))),col=rgb(255,255,0,80,maxColorValue = 255))
  }
    legend("topleft",legend=list("Null Distribution","Alternative Distribution","P(Type I Error)", "P(Type II Error)"),col=c("blue","red",rgb(160,160,160,40,maxColorValue = 255),rgb(255,255,0,80,maxColorValue = 255)),pch=15,lty=c(1,1,1,1))
  })
  
  output$stats<-renderUI({
    #get inputs
    mu0<-input$mu0
    n<-input$sampleSize
    sigma<-input$sigma
    muA<-input$muA
    alternative<-input$HA
    alpha<-input$alpha
    
    if(alternative=='Greater Than'){
      beta<-pnorm(qnorm(1-alpha)*sigma/sqrt(n)+mu0,mean=muA,sd=sigma/sqrt(n))
    }else if(alternative=='Less Than'){
      beta<-1-pnorm(qnorm(alpha)*sigma/sqrt(n)+mu0,mean=muA,sd=sigma/sqrt(n))      
    }else {
      beta<-pnorm(qnorm(1-alpha)*sigma/sqrt(n)+mu0,mean=muA,sd=sigma/sqrt(n))-pnorm(qnorm(alpha)*sigma/sqrt(n)+mu0,mean=muA,sd=sigma/sqrt(n))
    }
    
    list(
      withMathJax(HTML(
        paste0('$$Y\\stackrel{H_0}\\sim N(\\mu_0,\\sigma^2/n)=N(',mu0,',',sigma^2,'/',n,')=N(',mu0,',',round(sigma^2/n,4),')$$')
      )),
      withMathJax(HTML(
        paste0('$$Y\\stackrel{H_A}\\sim N(\\mu_A,\\sigma^2/n)=N(',muA,',',sigma^2,'/',n,')=N(',muA,',',round(sigma^2/n,4),')$$')
      )),
       withMathJax(HTML(
         paste0('$$\\alpha = ',alpha,'~~~~~~\\beta = ',round(beta,4),'~~~~~~PWR=1-\\beta = ',1-round(beta,4),'$$')
       ))
      )
  })
    
})    