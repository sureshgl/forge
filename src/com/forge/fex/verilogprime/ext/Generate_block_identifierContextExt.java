package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Generate_block_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Generate_block_identifierContextExt extends AbstractBaseExt {

	public Generate_block_identifierContextExt(Generate_block_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Generate_block_identifierContext getContext() {
		return (Generate_block_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).generate_block_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Generate_block_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Generate_block_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}