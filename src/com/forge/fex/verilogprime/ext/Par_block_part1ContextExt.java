package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Par_block_part1Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Par_block_part1ContextExt extends AbstractBaseExt {

	public Par_block_part1ContextExt(Par_block_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Par_block_part1Context getContext() {
		return (Par_block_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).par_block_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Par_block_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Par_block_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}