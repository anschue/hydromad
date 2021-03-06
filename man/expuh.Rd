\name{expuh}
\alias{expuh}
\alias{expuh.sim}
\alias{ssg.expuh}
\alias{normalise.expuh}
\title{ Exponential components transfer function models }
\description{
  A unit hydrograph (linear transfer function) defined as a system of
  exponentially receding components. Each component is defined by
  its time constant and fractional volume, and if there are multiple
  (up to 3) such components they may be in a parallel and/or
  series configuration. 
}
\usage{
expuh.sim(U, delay = 0,
          tau_s = 0, tau_q = 0, tau_3 = 0,
          v_s = 1, v_q = NA, v_3 = 0,
          series = 0, loss = 0,
          Xs_0 = 0, Xq_0 = 0, X3_0 = 0,
          pars = NULL,
          return_components = FALSE,
	  na.action = na.pass,
          epsilon = hydromad.getOption("sim.epsilon"))

ssg.expuh(theta)
normalise.expuh(theta)
%tfParsConvert(pars, form = c("a,b", "tau,v", "alpha,beta"))
}
\arguments{
  \item{U}{
    input time series.
  }
  \item{delay}{
    lag (dead time) between input and response, in time steps.
  }
  \item{tau_s, tau_q, tau_3}{
    time constants (\eqn{\tau}) for the exponential components.
  }
  \item{v_s, v_q, v_3}{
    fractional volumes (\var{v}) for the exponential components.
  }
  \item{series}{
    defines the configuration of exponential components, as being in
    parallel and/or series (for second or third order models). See Details.
  }
  \item{loss}{
    a constant loss (or gain, if negative) term subtracted from the
    \emph{slow} (\code{s}) component.
  }
  \item{Xs_0, Xq_0, X3_0}{
    initial values of the exponential components.
  }
  \item{pars}{
    the parameters as a named vector. If this is given, it
    will over-ride the named parmameter arguments. 
  }
  \item{return_components}{
    whether to return all component time series.
  }
  \item{na.action}{
    function to remove missing values,
    e.g. \code{\link[=na.omit.ts]{na.omit}}.
  }
  \item{epsilon}{
    values smaller than this in the output will be set to zero.
  }
  \item{theta}{
    the parameters as a named vector.
  }
}
\details{

  The \code{expuh} model is a transfer function translating an
  input time series \var{U} into an output series \var{X}.
  It describes a configuration of exponentially
  decaying components, each defined by a recession rate \eqn{\alpha} and
  peak response \eqn{\beta}. However, in hydrology these parameters are more
  easily interpreted in terms of time constants \eqn{\tau} (number of time
  steps to reduce to a fraction \eqn{1/e}, 37\%) and fractional volumes
  \var{v}. These are directly related as:
  
  \deqn{\tau = -1 / \log(\alpha)}

  \deqn{v = \beta / (1 - \alpha)}
  
  If there are two components in parallel, these are conventionally called
  slow (\var{s}) and quick (\var{q}) flow components. The total
  simulated flow \var{X} is the sum of these;
  \eqn{X[t] = X_s[t] + X_q[t]}, and: 

  \deqn{X_s[t] = \alpha_s X_s[t-1] + \beta_s U[t]}
  \deqn{X_q[t] = \alpha_q X_q[t-1] + \beta_q U[t]}
  
  Two components might also be arranged in series rather than parallel,
  in which case:

  \deqn{X_s[t] = \alpha_s X_s[t-1] + \beta_s U[t]}
  \deqn{X[t] = \alpha_q X[t-1] + \beta_q X_s[t]}
  
  This configuration is specified by the argument \code{series = 1}. The
  default \code{series = 0} specifies all components to be in parallel.
  
  In the case of three components, with corresponding time constants
  \eqn{\tau_s}, \eqn{\tau_q} and \eqn{tau_3} (\code{tau_s, tau_q,
  tau_3}), there are four possible types of configuration:
  
  \describe{
    \item{\code{series = 0}}{
      all 3 components in parallel, i.e. independent flows:
      \var{X = s + q + 3}. In this case \code{v_q} defaults to
      \code{1 - v_s - v_3} in order to ensure that the total volume is
      1. 
    }
    \item{\code{series = 1}}{
      one component in parallel with two in series: the \code{q}
      component is in series with the \code{3} component, and the
      \code{s} component is in parallel:
      \var{X = (q * 3) + s}. In this case \code{v_q} defaults to 1.
    }
    \item{\code{series = 2}}{
      two components in parallel with one in series: the \code{s}
      and \code{q} components are in parallel and the \code{3} component
      is in series:
      \var{X = 3 * (s + q)}. In this case \code{v_q} defaults to
      \code{1 - v_s} in order to ensure that the total volume of the
      parallel component is 1. The total volume will be 1 if \code{v_3}
      is also 1. 
    }
    \item{\code{series = 3}}{
      all 3 components in series: \var{X = s * q * 3}. 
      In this case \code{v_q} defaults to 1. The total volume will be 1
      if \code{v_s} and \code{v_3} are also 1.
    }
  }
}
\value{
	the model output as a \code{\link{ts}} object,
	with the same dimensions and time window as the input \code{U}.
	If \code{return_components = TRUE}, it will have multiple
	columns named
	\code{Xs}, \code{Xq} and, if relevant, \code{X3}.
}
\references{
	Jakeman, A.J., I.G. Littlewood, and P.G. Whitehead (1990),
	Computation of the instantaneous unit hydrograph and identifiable component flows
	with application to two small upland catchments,
	\emph{Journal of Hydrology}, 117: 275-300.
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link{expuh.sriv.fit}}
  \code{\link{armax}}
}
\examples{
data(HydroTestData)
mod1 <- hydromad(HydroTestData, routing = "expuh",
                 tau_s = 30, tau_q = 5, v_s = 0.5)
flowcomps <- predict(mod1, return_components = TRUE)
xyplot(cbind(`Slow component` = flowcomps[,"Xs"],
             `Total flow` = flowcomps[,1] + flowcomps[,2]),
       superpose = TRUE) +
  layer(panel.refline(h = 0))

U  <- ts(c(1, rep(0, 30)))
xyplot(cbind("tau_s = 10" = expuh.sim(U, tau_s = 10),
             "& tau_q = 1" = expuh.sim(U, tau_s = 10, tau_q = 1, v_s = 0.5),
             "&& v_s = 0.9" = expuh.sim(U, tau_s = 10, tau_q = 1, v_s = 0.9)),
       superpose = TRUE)
}
\keyword{ ts }

