\name{fitBySampling}
\alias{fitBySampling}
\title{
  Fit a hydromad model by sampling the parameter space.
}
\description{
  Fit a hydromad model by sampling the parameter space.
  Returns best result from sampling in parameter ranges using
  random, latin hypercube sampling, or a uniform grid (all
  combinations). The function also retains the parameter sets and
  objective function values, which can be used to define a
  \link[=defineFeasibleSet]{feasible parameter set}
}
\usage{
fitBySampling(MODEL, objective = hydromad.getOption("objective"),
              samples = hydromad.getOption("fit.samples"),
              sampletype = c("latin.hypercube", "random", "all.combinations"))
}
\arguments{
  \item{MODEL}{
    a model specification created by \code{\link{hydromad}}. It should
    not be fully specified, i.e one or more parameters should be defined
    by \emph{ranges} of values rather than exact values.
  }
  \item{objective}{
    objective function to maximise, given as a \code{function(Q, X, ...)}.
    See \code{\link{objFunVal}}.
  }
  \item{samples}{
    number of parameter sets to test.
  }
  \item{sampletype}{
    sampling scheme -- see \code{\link{parameterSets}}.
  }
}
\details{
  See \code{\link{parameterSets}}.
}
\value{
  the best model from those sampled, according to the given
  \code{objective} function.
}
\author{
  Felix Andrews \email{felix@nfrac.org}
}
\seealso{
  \code{\link{fitByOptim}},
  \code{\link{parameterSets}},
  \code{\link{objFunVal}}
}
\examples{

data(Cotter)
x <- Cotter[1:1000]

## IHACRES CWI model with armax unit hydrograph fitted by least squares
modx <- hydromad(x, sma = "cwi", routing = "armax", rfit = "ls")
modx

foo <- fitBySampling(modx)

summary(foo)

## plot objective function value improvement over time
xyplot(optimtrace(foo), type = "b",
  xlab = "function evaluations", ylab = "objective fn. value")
}
\keyword{ optimization }
