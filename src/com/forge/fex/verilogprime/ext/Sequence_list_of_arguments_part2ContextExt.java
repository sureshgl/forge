package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_list_of_arguments_part2Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_list_of_arguments_part2ContextExt extends AbstractBaseExt {

	public Sequence_list_of_arguments_part2ContextExt(Sequence_list_of_arguments_part2Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_list_of_arguments_part2Context getContext() {
		return (Sequence_list_of_arguments_part2Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_list_of_arguments_part2());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_list_of_arguments_part2Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_list_of_arguments_part2Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}