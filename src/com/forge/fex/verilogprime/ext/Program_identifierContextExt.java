package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Program_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Program_identifierContextExt extends AbstractBaseExt {

	public Program_identifierContextExt(Program_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Program_identifierContext getContext() {
		return (Program_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).program_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Program_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Program_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}