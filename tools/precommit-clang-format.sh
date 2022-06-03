if [[ -n "${PRE_COMMIT_TO_REF}" ]]; then

    parsed_to_ref=$(git rev-parse $PRE_COMMIT_TO_REF)
    head_ref=$(git rev-parse HEAD)

    echo WE ARE HERE 1

    # If we are comparing to not comparing to HEAD, changes cannot be safely
    # applied, all we can do is print the diff and exit
    if [[ $PRE_COMMIT_TO_REF != $head_ref ]]; then
        echo WE ARE HERE 2
        echo git-clang-format $PRE_COMMIT_FROM_REF $PRE_COMMIT_TO_REF --diff $@
        output=$(git-clang-format $PRE_COMMIT_FROM_REF $PRE_COMMIT_TO_REF --diff $@)
        exitcode=$?

        echo $output

        if [[ $output = "no modified files to format" ]]; then
            exit 0
        fi

        if [[ exitcode -eq 0 ]]; then
            # git-clang-format exits 0 even if a diff is created, so we need to
            # make sure the test fails
            echo "Changes exist but cannot be applied to refs other than HEAD"
            exit 1
        fi

        exit $exitcode
    fi
fi

# Otherwise, our current ref is active and the tool can edit it
echo WE ARE HERE 3
git-clang-format $PRE_COMMIT_FROM_REF $@
