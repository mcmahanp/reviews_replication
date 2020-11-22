library(brms)

###
# Load data
###
dta <- read.csv('dta_comm.csv.gz')


###
# 5% subsample analysis
###
# Note: This is _very_ slow.
#       Parallelization is strongly recommended, but even with significant
#       parallel execution it will take days or weeks to complete.
###

fit_5pct <- brm(
    mvbind(scale(avg_path_length_rratio_delta),scale(transitivity_rratio_delta)) ~
        scale(num_vertices) + I(scale(num_vertices)**2) +
        scale(density_0) + I(scale(density_0)**2) +
        scale(avg_path_length_rratio_0) +
        scale(transitivity_rratio_0) +
        is_review,
    data=dta,
    inits="0",
    prior = c(
        set_prior("normal(0,2)", class = "b"),
        set_prior("lkj(2)", class = "Lrescor")),
    warmup = 800, iter = 1300, chains = 8, cores=8,
    control = list(adapt_delta = 0.95)
    ## uncomment the following line if you have  (lots of) cores to spare and
    ## want to use within-chain parallelization (requires `cmdstanr`):
    ,backend = "cmdstanr", threads = threading(8)
)
